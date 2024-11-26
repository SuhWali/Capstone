# utils.py
import os
import json
import base64
import logging
import tempfile
from typing import List, Dict, Tuple

from PIL import Image
from pdf2image import convert_from_path
from pathlib import Path
from django.conf import settings
from langchain import schema  # pylint: disable=E1101
from langchain_openai import ChatOpenAI


class DocumentAnalyzer:
    def __init__(self, dpi: int = 200):
        self.pdf_processor = PDFProcessor(dpi=dpi)
        self.model = ChatOpenAI(
            model="gpt-4o-mini",
            max_tokens=4096,
            temperature=0,
            openai_api_key=settings.OPENAI_API_KEY
        )
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger(__name__)

    def get_analysis_paths(self, document_path: str) -> Tuple[str, str]:
        """Generate paths for both analysis result files."""
        base_path = Path(document_path)
        concepts_path = str(base_path.parent /
                            f"{base_path.stem}_concepts.json")
        exercises_path = str(base_path.parent /
                             f"{base_path.stem}_exercises.json")
        return concepts_path, exercises_path

    def analyze_document(self, document: 'Document') -> tuple:
        """Perform both types of analysis on a document and save results to files."""
        try:
            metadata = {
                'grade': document.domain.grade.gradename,
                'domain': document.domain.domainname,
                'file_name': os.path.basename(document.file.name)
            }

            self.logger.info(f"Starting analysis for document: {
                            metadata['file_name']}"
                            )

            # Get base64 images once for both analyses
            base64_images = self.pdf_processor.pdf_to_images(
                document.file.path)

            # Perform concepts analysis
            concepts_result = self.pdf_processor.process_concepts(
                base64_images=base64_images,
                metadata=metadata,
                model=self.model
            )

            # Perform exercises analysis
            exercises_result = self.pdf_processor.process_exercises(
                base64_images=base64_images,
                metadata=metadata,
                model=self.model
            )

            # Parse and save both results
            concepts_data = self._parse_json_response(concepts_result.content)
            exercises_data = self._parse_json_response(
                exercises_result.content)

            concepts_path, exercises_path = self.get_analysis_paths(
                document.file.path)
            os.makedirs(os.path.dirname(concepts_path), exist_ok=True)

            # Save concepts analysis
            with open(concepts_path, 'w', encoding='utf-8') as f:
                json.dump(concepts_data, f, indent=2)

            # Save exercises analysis
            with open(exercises_path, 'w', encoding='utf-8') as f:
                json.dump(exercises_data, f, indent=2)

            self.logger.info(f"Analysis completed and saved to: {
                             concepts_path} and {exercises_path}")
            return {
                'concepts': concepts_data,
                'exercises': exercises_data,
                'paths': {
                    'concepts': concepts_path,
                    'exercises': exercises_path
                }
            }

        except Exception as e:
            self.logger.error(f"Error analyzing document: {str(e)}")
            raise

    def _parse_json_response(self, content: str) -> dict:
        """Parse JSON from model response."""
        try:
            return json.loads(content)
        except json.JSONDecodeError:
            content = content.strip()
            start_idx = content.find('{')
            end_idx = content.rfind('}') + 1
            if start_idx != -1 and end_idx != 0:
                json_str = content[start_idx:end_idx]
                return json.loads(json_str)
            raise ValueError("Could not extract valid JSON from response")

    def get_analysis_result(self, document: 'Document', analysis_type: str = 'both') -> dict:
        """Retrieve analysis results from files."""
        concepts_path, exercises_path = self.get_analysis_paths(
            document.file.path)
        result = {}

        if analysis_type in ['both', 'concepts'] and os.path.exists(concepts_path):
            with open(concepts_path, 'r', encoding='utf-8') as f:
                result['concepts'] = json.load(f)

        if analysis_type in ['both', 'exercises'] and os.path.exists(exercises_path):
            with open(exercises_path, 'r', encoding='utf-8') as f:
                result['exercises'] = json.load(f)

        return result if result else None


class PDFProcessor:
    def __init__(self, dpi: int = 200):
        self.dpi = dpi
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger(__name__)

    def pdf_to_images(self, pdf_path: str) -> List[str]:
        try:
            self.logger.info(f"Converting PDF: {pdf_path}")
            images = convert_from_path(
                pdf_path,
                dpi=self.dpi,
                fmt='JPEG',
                thread_count=4
            )

            base64_images = []

            with tempfile.TemporaryDirectory() as temp_dir:
                for i, image in enumerate(images):
                    image = self.optimize_image(image)

                    temp_path = os.path.join(temp_dir, f'page_{i}.jpg')
                    image.save(temp_path, 'JPEG', quality=85)

                    base64_str = self.encode_image(temp_path)
                    base64_images.append(base64_str)

                    self.logger.info(f"Processed page {i+1}/{len(images)}")

            return base64_images

        except Exception as e:
            self.logger.error(f"Error processing PDF: {str(e)}")
            raise

    def optimize_image(self, image: Image.Image) -> Image.Image:
        max_dimension = 2000
        ratio = min(max_dimension / max(image.size[0], image.size[1]), 1.0)
        new_size = tuple(int(dim * ratio) for dim in image.size)

        if ratio < 1.0:
            image = image.resize(new_size, Image.Resampling.LANCZOS)

        return image

    @staticmethod
    def encode_image(image_path: str) -> str:
        with open(image_path, "rb") as image_file:
            return base64.b64encode(image_file.read()).decode('utf-8')

    def process_concepts(self, base64_images: List[str], metadata: Dict, model) -> dict:
        """Process document for concepts analysis."""
        content = [
            {
                "type": "text",
                "text": f"""
You are an advanced AI assistant tasked with extracting key math exercises, problems, examples, and their underlying concepts from a document. The document was uploaded with the following metadata:
1. **Grade level:** {metadata['grade']}
2. **Domain/Module:** {metadata['domain']}
3. **File name:** {metadata['file_name']}
        Your goals are:
1. Identify the **concepts** covered in the document (e.g., algebra, calculus, geometry).
2. For each concept, extract its name and provide a concise description based on the content of the document.
3. Optionally infer the significance of the grade level, domain/module, or file name if it helps clarify the concepts or content.
### Output Schema:
{{
  "concepts": [
    {{
      "name": "string (name of the concept)",
      "description": "string (description of the concept)"
    }}
  ]
}}"""
            }
        ]

        return self._process_content(content, base64_images, model)

    def process_exercises(self, base64_images: List[str], metadata: Dict, model) -> dict:
        """Process document for exercises analysis."""
        content = [
            {
                "type": "text",
                "text": f"""
You are an intelligent assistant tasked with extracting math exercises, problems, and examples from documents. Your job is to:
1. Identify all math-related content, including equations, problems, and text explanations.
2. Extract equations in LaTeX format if they are complex (e.g., fractions, integrals, summations, or multi-line equations).
3. Extract normal text as plain text if it does not involve complex math symbols or structures.
4. Structure the output in JSON format as specified below:

The document metadata is:
- Grade level: {metadata['grade']}
- Domain/Module: {metadata['domain']}
- File name: {metadata['file_name']}

Output Schema:
{{
  "problems": [
    {{
      "type": "exercise",
      "content": "\\\\text{{Is it necessary to do all of the calculations to determine the sign of the product? Why or why not?}} \\\\[(-5) \\\\times (-5) \\\\times \\\\cdots \\\\times (-5) = (-5)^{{95}}\\\\] \\\\text{{95 times}}",
      "concept": "This concept explores how the sign of the base and the exponent affects the outcome of the multiplication, particularly focusing on when the base is negative and how the exponent's parity (even or odd) influences the sign of the result"
    }}
  ]
}}"""
            }
        ]

        return self._process_content(content, base64_images, model)

    def _process_content(self, initial_content: List[Dict], base64_images: List[str], model) -> dict:
        """Process content with base64 images."""
        content = initial_content.copy()

        for base64_image in base64_images:
            content.append({
                "type": "image_url",
                "image_url": {"url": f"data:image/jpeg;base64,{base64_image}"}
            })

        message = schema.HumanMessage(content=content)
        return model.invoke([message])

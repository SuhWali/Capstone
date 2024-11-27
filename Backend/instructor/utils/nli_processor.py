# utils/nli_processor.py
import torch
from typing import List, Dict, Optional, Tuple
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import json
import logging
from dataclasses import dataclass
from pathlib import Path

@dataclass
class NLIResult:
    entailment: float
    neutral: float
    contradiction: float
    text1: str
    text2: str

    @property
    def max_score(self) -> float:
        return self.entailment

    # @property
    # def relationship(self) -> str:
    #     scores = {
    #         'entailment': self.entailment,
    #         'contradiction': self.contradiction,
    #         'neutral': self.neutral
    #     }
    #     return max(scores.items(), key=lambda x: x[1])[0]

class NLIProcessor:
    def __init__(self, model_name: str = "ynie/xlnet-large-cased-snli_mnli_fever_anli_R1_R2_R3-nli"):
        self.model_name = model_name
        self.max_length = 256
        self.threshold = 0.7  # Configurable threshold for relationship strength
        
        # Initialize logger
        self.logger = logging.getLogger(__name__)
        
        # Load model and tokenizer
        self.logger.info(f"Loading NLI model: {model_name}")
        self.tokenizer = AutoTokenizer.from_pretrained(model_name)
        self.model = AutoModelForSequenceClassification.from_pretrained(model_name)
        
        # Move model to GPU if available
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.model.to(self.device)
        self.model.eval()  # Set to evaluation mode

    def process_pair(self, premise: str, hypothesis: str) -> NLIResult:
        """Process a single premise-hypothesis pair."""
        try:
            # Tokenize
            inputs = self.tokenizer.encode_plus(
                premise,
                hypothesis,
                max_length=self.max_length,
                return_token_type_ids=True,
                truncation=True,
                padding='max_length',
                return_tensors='pt'
            )

            # Move inputs to same device as model
            inputs = {k: v.to(self.device) for k, v in inputs.items()}

            # Get predictions
            with torch.no_grad():
                outputs = self.model(**inputs)
                probabilities = torch.softmax(outputs.logits, dim=1)[0]

            # Create result object
            result = NLIResult(
                entailment=probabilities[0].item(),
                neutral=probabilities[1].item(),
                contradiction=probabilities[2].item(),
                
                text1=premise,
                text2=hypothesis
            )

            return result

        except Exception as e:
            self.logger.error(f"Error processing NLI pair: {str(e)}")
            raise

    def process_concept_against_clusters(self,
                                      concept_description: str,
                                      clusters: List['Cluster']) -> List[Tuple['Cluster', NLIResult]]:
        """Process a concept description against multiple clusters."""
        results = []
        for cluster in clusters:
            result = self.process_pair(concept_description, cluster.clustername)
            if result.max_score >= self.threshold:
                # print(result)
                results.append((cluster, result))
        
        return sorted(results, key=lambda x: x[1].max_score, reverse=True)

    def process_concept_against_standards(self,
                                       concept_description: str,
                                       standards: List['Standard']) -> List[Tuple['Standard', NLIResult]]:
        
        """Process a concept description against multiple standards."""
        results = []
        for standard in standards:
            result = self.process_pair(concept_description, standard.standarddescription)
            print(result)
            if result.max_score >= self.threshold:
                results.append((standard, result))
        
        return sorted(results, key=lambda x: x[1].max_score, reverse=True)

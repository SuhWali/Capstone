# utils/content_processor.py
from typing import Dict, List, Tuple, Optional
from django.db import transaction
from .nli_processor import NLIProcessor
import json
import logging
from django.utils import timezone

class ContentProcessor:
    def __init__(self, threshold: float = 0.7):
        self.nli_processor = NLIProcessor()  # Using the existing NLIProcessor
        self.threshold = threshold
        self.logger = logging.getLogger(__name__)


    def process_document_content(self, document: 'Document') -> Dict:
        """Process document content and populate related tables."""
        from ..models import Clusters
        try:
            concepts_path, exercises_path = document.get_analysis_paths()
            
            # Load content from files
            with open(concepts_path, 'r') as f:
                concepts_data = json.load(f)
            
            with open(exercises_path, 'r') as f:
                exercises_data = json.load(f)

     

            # Get all relevant clusters for the grade
            grade_clusters = Clusters.objects.filter(
                domainid__grade=document.domain.grade
            )

            # Process and store results
            results = {
            'document_standards': self._process_concepts(document, concepts_data, grade_clusters),
            'exercises': self._process_exercises(document, exercises_data, grade_clusters),
            'examples': self._process_examples(document, exercises_path, grade_clusters),
            'metadata': {
                'grade': document.domain.grade.gradename,
                'domain': document.domain.domainname,
                'analysis_date': timezone.now().isoformat()
            }
        }

            return results

        except Exception as e:
            self.logger.error(f"Error processing document content: {str(e)}")
            raise

    def _process_concepts(self, 
                         document: 'Document', 
                         concepts_data: Dict,
                         clusters: List['Cluster']) -> List[Dict]:
        """Process concepts using NLI and create document-standard relationships."""
        from ..models import Standards, DocumentStandard
        
        results = []
        for concept in concepts_data.get('concepts', []):
            # First level: Process against clusters
            cluster_matches = self.nli_processor.process_concept_against_clusters(
                concept['description'],
                clusters
            )
            # print(cluster_matches, "the moment of truth")
            
            # Second level: For matching clusters, process against their standards
            for cluster, cluster_result in cluster_matches:
                if cluster_result.max_score >= self.threshold:
            
                    standards = Standards.objects.filter(clusterid=cluster)
                    # print(standards, "standard\n", cluster, "cluster ")
                    standard_matches = self.nli_processor.process_concept_against_standards(
                        concept['description'],
                        standards
                    )
                    
                    # Create relationships for matching standards
                    for standard, nli_result in standard_matches:
                        if nli_result.max_score >= self.threshold:
                            
                            doc_standard, created = DocumentStandard.objects.get_or_create(
                                document=document,
                                standard=standard,
                                confidence_score=nli_result.max_score,
                                # relationship_type=nli_result.relationship
                            )

                            if not created and nli_result.max_score > doc_standard.confidence_score:
                                doc_standard.confidence_score = nli_result.max_score
                                doc_standard.save()
                            
                            results.append({
                                'concept': concept['name'],
                                'standard_id': standard.standardid,
                                'cluster_id': cluster.clusterid,
                                'score': nli_result.max_score,
                                # 'relationship': nli_result.relationship
                            })
        
        return results

    def _process_exercises(self, 
                          document: 'Document', 
                          content_data: Dict,
                          clusters: List['Cluster']) -> List[Dict]:
        """Process exercises using NLI and create relationships."""
        from ..models import Exercise, Standards, ExerciseStandard
        
        results = []
        for problem in content_data.get('problems', []):
            if problem.get('type') not in ['exercise', 'problem']:
                continue

            # Create exercise record
            exercise = Exercise.objects.create(
                # document=document,
                type=problem['type'],
                content=problem['content'],
                context=problem['concept']
            )
            # print("we are HERE")
            # print(problem['concept'])

            # Process against clusters first
            cluster_matches = self.nli_processor.process_concept_against_clusters(
                problem['concept'],
                clusters
            )
            
            # For matching clusters, process against standards
            for cluster, cluster_result in cluster_matches:
                if cluster_result.max_score >= self.threshold:
                    standards = Standards.objects.filter(clusterid=cluster)
                    standard_matches = self.nli_processor.process_concept_against_standards(
                        problem['concept'],
                        standards
                    )
                    
                    # Create relationships for matching standards
                    for standard, nli_result in standard_matches:
                        if nli_result.max_score >= self.threshold:
                            ExerciseStandard.objects.create(
                                exercise=exercise,
                                standard=standard,
                                confidence_score=nli_result.max_score,
                                # relationship_type=nli_result.relationship
                            )
            
            results.append({
                'exercise_id': exercise.exercise_id,
                'content': problem['content'][:100] + '...',
                # 'standards_count': exercise.standards.count()
            })
        
        return results

    def _process_examples(self, 
                         document: 'Document', 
                         content_data: Dict,
                         clusters: List['Cluster']) -> List[Dict]:
        """Process examples using NLI and create relationships."""
        from ..models import Example, Standards, ExampleStandard
        
        results = []
        for problem in content_data.get('problems', []):
            if problem.get('type') != 'example':
                continue

            # Create example record
            example = Example.objects.create(
                document=document,
                type=problem['type'],
                content=problem['content'],
                context=problem.get('context', '')
            )

            # Process against clusters first
            cluster_matches = self.nli_processor.process_concept_against_clusters(
                problem['content'],
                clusters
            )
            
            # For matching clusters, process against standards
            for cluster, cluster_result in cluster_matches:
                if cluster_result.max_score >= self.threshold:
                    standards = Standard.objects.filter(cluster=cluster)
                    standard_matches = self.nli_processor.process_concept_against_standards(
                        problem['content'],
                        standards
                    )
                    
                    # Create relationships for matching standards
                    for standard, nli_result in standard_matches:
                        if nli_result.max_score >= self.threshold:
                            ExampleStandard.objects.create(
                                example=example,
                                standard=standard,
                                confidence_score=nli_result.max_score,
                                # relationship_type=nli_result.relationship
                            )
            
            results.append({
                'example_id': example.example_id,
                'content': problem['content'][:100] + '...',
                'standards_count': example.standards.count()
            })
        
        return results
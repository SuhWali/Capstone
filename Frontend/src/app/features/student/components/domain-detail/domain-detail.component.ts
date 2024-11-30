import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { ActivatedRoute, Router, } from '@angular/router';
import { StudentService } from '../../services/student.service';
import { DocumentModel, Domain, Assessment, AssessmentExercise, CourseEnrollment, Recommendation } from '../../models/student.models';
import { Observable, switchMap, filter, take } from 'rxjs';


type MainTab = 'documents' | 'exercises';
type RecommendationTab = 'exercises' | 'examples' | 'documents';


@Component({
  selector: 'app-domain-detail',
  templateUrl: './domain-detail.component.html'
})
export class DomainDetailComponent implements OnInit {
  activeTab: 'documents' | 'exercises' = 'documents';
  activeRecommendationTab: RecommendationTab = 'exercises';



  documents$: Observable<DocumentModel[]>;
  selectedCourse$ = this.studentService.selectedCourse$;
  domainId: number;
  assessments$: Observable<Assessment[]>;
  selectedAssessment: Assessment | null = null;
  exercises$: Observable<AssessmentExercise[]> | null = null;
  private previousExerciseCount = 0;
  exerciseAnswers: { [key: number]: string } = {};
    exerciseRecommendations: { [key: number]: {
        exercises: Recommendation[];
        examples: Recommendation[];
        documents: Recommendation[];
    }} = {};



  constructor(
    private studentService: StudentService,
    private route: ActivatedRoute,
    private router: Router,
    private cdr: ChangeDetectorRef

  ) {
    this.domainId = 0;
    this.documents$ = new Observable<DocumentModel[]>();
    this.assessments$ = new Observable<Assessment[]>();
  }

  ngOnInit() {
    // Get domain ID from route and fetch documents
    this.documents$ = this.route.params.pipe(
      switchMap(params => {
        this.domainId = +params['id'];
        return this.studentService.getDomainDocuments(this.domainId);
      })
    );

    this.assessments$ = this.selectedCourse$.pipe(
      filter((enrollment): enrollment is CourseEnrollment => enrollment !== null),
      switchMap(enrollment => this.studentService.getAssessments(enrollment.course.id))
    );


  }

  loadRecommendations(exerciseId: number) {
    this.studentService.getRecommendations(exerciseId).pipe(
      take(1)
    ).subscribe(recommendations => {
      this.exerciseRecommendations[exerciseId] = recommendations;
      this.cdr.detectChanges();
    });
  }

  onAnswerChange(exerciseId: number, event: Event) {
    const value = (event.target as HTMLTextAreaElement).value;
    this.exerciseAnswers[exerciseId] = value;
    console.log(exerciseId)
    if (!this.exerciseRecommendations[exerciseId]) {
        this.loadRecommendations(exerciseId);
    }
}

  navigateToContent(type: string, id: number) {
    switch (type) {
      case 'exercise':
        this.router.navigate(['/student/exercise', id]);
        break;
      case 'example':
        this.router.navigate(['/student/example', id]);
        break;
      case 'document':
        this.router.navigate(['/student/document', id]);
        break;
    }
  }

  selectAssessment(assessment: Assessment) {
    this.selectedAssessment = assessment;
    this.exercises$ = this.studentService.getAssessmentExercises(assessment.id);
  }

  // Helper method to render LaTeX after view updates
  // Add this method to safely render LaTeX content
  renderLatex(content: string): string {
    // Wrap the content in LaTeX delimiters if not already present
    if (!content.includes('$$')) {
      return `$$${content}$$`;
    }
    return content;
  }

  ngAfterViewChecked() {
    // Get the current number of exercises on the page
    const currentExerciseCount = document.querySelectorAll('.exercise-content').length;

    // Only re-render if the number of exercises has changed
    if (currentExerciseCount !== this.previousExerciseCount) {
      this.previousExerciseCount = currentExerciseCount;
      this.renderMathContent();
    }
  }




  renderMathContent() {
    if (typeof window !== 'undefined' && (window as any).MathJax) {
      const MathJax = (window as any).MathJax;
      MathJax.typesetPromise?.()?.catch((err: any) => console.error('MathJax error:', err));
    }
  }

  setActiveTab(tab: 'documents' | 'exercises') {
    this.activeTab = tab;
  }
  setActiveRecommendationTab(tab: RecommendationTab) {
    this.activeRecommendationTab = tab;
}

  goBack() {
    this.router.navigate(['/student/course-domains']);
  }

  downloadDocument(document: DocumentModel) {
    window.open(document.file, '_blank');
  }
}
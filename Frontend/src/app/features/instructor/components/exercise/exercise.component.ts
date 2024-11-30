import { Component, OnInit, Input } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { InstructorService } from '../../services/instructor.service';
import { Observable, Subscription } from 'rxjs';
import { Domain, Cluster, Standard } from '../../models/instructor.models';


@Component({
  selector: 'app-exercise',
  templateUrl: './exercise.component.html',
  styleUrl: './exercise.component.css'
})
export class ExerciseComponent {
  @Input() domainId!: number;
  courseId: number = 0;
  generateForm: FormGroup;
  isGenerating = false;
  clusters$: Observable<Cluster[]> = new Observable();
  standards$: Observable<Standard[]> = new Observable();
  private subscription: Subscription = new Subscription();

  constructor(
    private fb: FormBuilder,
    private instructorService: InstructorService
  ) {
    this.generateForm = this.fb.group({
      title: ['', Validators.required],
      course: ['', Validators.required],
      num_exercises: [10, [Validators.required, Validators.min(1)]],
      domain_id: [''],
      cluster_id: [''],
      standard_id: ['']
    });
  }

  ngOnInit() {
    this.subscription.add(
      this.instructorService.getMyCourses().subscribe(courses => {
        if (courses.length > 0) {
          this.courseId = courses[0].id;
          this.generateForm.patchValue({ 
            course: this.courseId,
            domain_id: this.domainId 
          });
        }
      })
    );

    this.clusters$ = this.instructorService.getClusters(this.domainId);
    this.generateForm.get('cluster_id')?.valueChanges.subscribe(clusterId => {
      if (clusterId) {
        this.standards$ = this.instructorService.getStandards(clusterId);
      }
    });
  }

  ngOnDestroy() {
    this.subscription.unsubscribe();
  }

  onSubmit() {
    console.log(this.generateForm.value)
    if (this.generateForm.valid) {
      this.isGenerating = true;
      this.instructorService.generateAssessment(this.generateForm.value).subscribe({
        next: () => {
          this.isGenerating = false;
          this.generateForm.reset({ num_exercises: 10, domain_id: this.domainId });
        },
        error: () => {
          this.isGenerating = false;
        }
      });
    }
  }



}

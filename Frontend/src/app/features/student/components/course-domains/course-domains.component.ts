import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { StudentService } from '../../services/student.service';
import { CourseEnrollment, Domain } from '../../models/student.models';
import { Observable, Subscription, filter, switchMap } from 'rxjs';

@Component({
    selector: 'app-course-domains',
    templateUrl: './course-domains.component.html'
})
export class CourseDomainsComponent implements OnInit, OnDestroy {
    domains$: Observable<Domain[]> = new Observable();
    selectedCourse$ = this.studentService.selectedCourse$;
    private subscription: Subscription;

    constructor(
        private studentService: StudentService,
        private router: Router
    ) {
        this.subscription = this.selectedCourse$.pipe(
            filter((enrollment): enrollment is CourseEnrollment => enrollment !== null)
        ).subscribe(enrollment => {
            this.domains$ = this.studentService.getDomains(enrollment.course.id);
        });
    }

    ngOnInit() {
        // Check if we have a selected course
        const currentCourse = this.studentService.getSelectedCourse();
        if (!currentCourse) {
            // If no course is selected, redirect back to course selection
            this.router.navigate(['/student/courses']);
            return;
        }

        // Initialize domains based on selected course
        this.domains$ = this.selectedCourse$.pipe(
            filter((enrollment): enrollment is CourseEnrollment => enrollment !== null),
            switchMap(enrollment => this.studentService.getDomains(enrollment.course.id))
        );
    }

    ngOnDestroy() {
        this.subscription.unsubscribe();
    }

    goBack() {
        this.router.navigate(['/student/course']);
    }

    selectDomain(domain: Domain) {
        // this.router.navigate(['/instructor/domain', domain.domainid]);

        this.router.navigate(['/student/domain-detail', domain.domainid]);
    }
}

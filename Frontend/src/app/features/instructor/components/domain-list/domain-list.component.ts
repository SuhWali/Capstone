import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { InstructorService } from '../../services/instructor.service'
import { Grade, Domain } from '../../models/instructor.models'
import { Observable, Subscription, filter, switchMap } from 'rxjs';

@Component({
    selector: 'app-domain-list',
    templateUrl: './domain-list.component.html',
    //   styleUrl: './home.component.css'
})

export class DomainListComponent implements  OnDestroy {
    domains$: Observable<Domain[]> = new Observable();
    selectedGrade$ = this.instructorService.selectedGrade$;
    private subscription: Subscription;

    constructor(
        private instructorService: InstructorService,
        private router: Router
    ) {
        this.subscription = this.selectedGrade$.pipe(
            filter((grade): grade is Grade => grade !== null)
        ).subscribe(grade => {
            this.domains$ = this.instructorService.getDomains(grade.gradeid);
        });
    }

    ngOnInit() {
        // Check if we have a selected grade
        const currentGrade = this.instructorService.getSelectedGrade();
        if (!currentGrade) {
            // If no grade is selected, redirect back to grade selection
            this.router.navigate(['/instructor/grades']);
            return;
        }

        // Initialize domains based on selected grade
        this.domains$ = this.selectedGrade$.pipe(
            filter((grade): grade is Grade => grade !== null),
            switchMap(grade => this.instructorService.getDomains(grade.gradeid))
        );
    }

    ngOnDestroy() {
        this.subscription.unsubscribe();
    }

    goBack() {
        this.router.navigate(['/instructor/grades']);
    }

    selectDomain(domain: Domain) {
        this.router.navigate(['/instructor/domain', domain.domainid]);
    }
}

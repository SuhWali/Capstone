import { Component, OnInit } from '@angular/core';
import {  Router } from '@angular/router';
import { InstructorService } from '../../services/instructor.service'
import { Grade } from '../../models/instructor.models'


@Component({
    selector: 'app-grade-selection',
    templateUrl: './grade-selection.component.html',
    //   styleUrl: './home.component.css'
})
export class GradeSelectionComponent  {
    grades$ = this.instructorService.getMyGrades();
    constructor(
        private instructorService: InstructorService,
        private router: Router
    ) { }
    // ngOnInit(): void {
    //     throw new Error('Method not implemented.');
    // }

    selectGrade(grade: Grade) {
        this.instructorService.setSelectedGrade(grade);
        this.router.navigate(['/instructor/modules']);
    }
}
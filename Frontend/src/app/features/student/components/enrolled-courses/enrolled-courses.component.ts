import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { StudentService } from '../../services/student.service';
import { CourseEnrollment } from '../../models/student.models';

@Component({
    selector: 'app-enrolled-courses',
    templateUrl: './enrolled-courses.component.html'
})
export class EnrolledCoursesComponent {
    enrolledCourses$ = this.studentService.getEnrolledCourses();

    constructor(
        private studentService: StudentService,
        private router: Router
    ) {}

    selectCourse(enrollment: CourseEnrollment) {
        this.studentService.setSelectedCourse(enrollment);
        this.router.navigate(['/student/course-detail']);
    }
}
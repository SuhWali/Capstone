import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { CourseEnrollment, Domain, DocumentModel, AssessmentExercise, Assessment, Recommendation } from '../models/student.models';
import { environment } from '../../../../environments/environment';

@Injectable({
    providedIn: 'root'
})
export class StudentService {
    private apiUrl = `${environment.apiUrl}/student/enrollments`;
    private selectedCourseSubject = new BehaviorSubject<CourseEnrollment | null>(null);
    selectedCourse$ = this.selectedCourseSubject.asObservable();
    

    constructor(private http: HttpClient) {}

    getEnrolledCourses(): Observable<CourseEnrollment[]> {
        return this.http.get<CourseEnrollment[]>(this.apiUrl);
    }

    setSelectedCourse(course: CourseEnrollment) {
        this.selectedCourseSubject.next(course);
    }

    getDomains(courseId: number): Observable<Domain[]> {
        return this.http.get<Domain[]>(`${this.apiUrl}/my_domains/?course=${courseId}`);
    }

    getSelectedCourse(): CourseEnrollment | null {
        return this.selectedCourseSubject.getValue();
    }

    getDomainDocuments(domainId: number): Observable<DocumentModel[]> {
        return this.http.get<DocumentModel[]>(`${this.apiUrl}/domain_documents/?domain=${domainId}`);
    }

    getAssessments(courseId: number): Observable<Assessment[]> {
        return this.http.get<Assessment[]>(`${this.apiUrl}/1/assessments/`);
    }

    getAssessmentExercises(assessmentId: number): Observable<AssessmentExercise[]> {
        return this.http.get<AssessmentExercise[]>(`${this.apiUrl}/${assessmentId}/exercises/`);
    }

    getRecommendations(exerciseId: number): Observable<{
        exercises: Recommendation[];
        examples: Recommendation[];
        documents: Recommendation[];
    }> {
        return this.http.get<any>(`${this.apiUrl}/${exerciseId}/recommendations/`);
    }

}
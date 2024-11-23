import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { Grade, Domain, Document } from '../models/instructor.models';

@Injectable()
export class InstructorService {
    private apiUrl = environment.apiUrl;
    private selectedGrade = new BehaviorSubject<Grade | null>(null);
    selectedGrade$ = this.selectedGrade.asObservable();

    constructor(private http: HttpClient) { }

    setSelectedGrade(grade: Grade) {
        this.selectedGrade.next(grade);
    }

    getMyGrades(): Observable<Grade[]> {
        return this.http.get<Grade[]>(`${this.apiUrl}/instructor/instructor/my_grades/`);
    }

    getDomains(gradeId: number): Observable<Domain[]> {
        return this.http.get<Domain[]>(`${this.apiUrl}/instructor/instructor/my_domains/?grade=${gradeId}`);
    }

    getDomain(id: number): Observable<Domain> {
        return this.http.get<Domain>(`${this.apiUrl}/instructor/instructor/domains/${id}/`);
    }

    getDocuments(domainId: number): Observable<Document[]> {
        return this.http.get<Document[]>(`${this.apiUrl}/instructor/instructor/documents/`, {
            params: { domain: domainId.toString() }
        });
    }

    uploadDocument(document: FormData): Observable<Document> {
        return this.http.post<Document>(`${this.apiUrl}/instructor/instructor/documents/`, document);
    }

    deleteDocument(id: number): Observable<void> {
        return this.http.delete<void>(`${this.apiUrl}/instructor/instructor/documents/${id}/`);
    }
}
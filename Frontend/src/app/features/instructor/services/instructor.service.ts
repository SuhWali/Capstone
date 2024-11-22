import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../../../src/environments/environment';
import { Grade, Domain, Document } from '../models/instructor.models';

@Injectable({
    providedIn: 'root'
})
export class InstructorService {
    private apiUrl = environment.apiUrl;

    constructor(private http: HttpClient) { }

    getMyGrades(): Observable<Grade[]> {
        return this.http.get<Grade[]>(`${this.apiUrl}/instructor/my_grades/`);
    }

    getMyDomains(): Observable<Domain[]> {
        return this.http.get<Domain[]>(`${this.apiUrl}/instructor/my_domains/`);
    }

    uploadDocument(document: FormData): Observable<Document> {
        return this.http.post<Document>(`${this.apiUrl}/documents/`, document);
    }

    getDocuments(): Observable<Document[]> {
        return this.http.get<Document[]>(`${this.apiUrl}/documents/`);
    }

    deleteDocument(id: number): Observable<void> {
        return this.http.delete<void>(`${this.apiUrl}/documents/${id}/`);
    }
}
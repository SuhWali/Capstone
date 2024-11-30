
import { Component, OnInit, Input } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { InstructorService } from '../../services/instructor.service';
import { Document, Domain } from '../../models/instructor.models';
import { BehaviorSubject, Observable, switchMap } from 'rxjs';

@Component({
    selector: 'app-document-management',
    templateUrl: './document-management.component.html',
})

export class DocumentManagementComponent implements OnInit {
    @Input() domainId!: number;
    uploadForm: FormGroup;
    isUploading = false;
    documents$ = new BehaviorSubject<Document[]>([]);
    currentDomain$: Observable<Domain> = new Observable();
    // private domainId: number = 0;


    constructor(
        private fb: FormBuilder,
        private route: ActivatedRoute,
        private router: Router,
        private instructorService: InstructorService
    ) {
        this.uploadForm = this.fb.group({
            title: ['', Validators.required],
            description: [''],
            file: [null, Validators.required]
        });
    }


    ngOnInit() {
        this.route.params.pipe(
            switchMap(params => {
                this.domainId = +params['domainId'];
                return this.instructorService.getDomain(this.domainId);
            })
        ).subscribe(domain => {
            this.currentDomain$ = new BehaviorSubject(domain);
            this.loadDocuments();
        });
    }

    onFileChange(event: Event) {
        const file = (event.target as HTMLInputElement).files?.[0];
        if (file) {
            // Get the file name without extension
            const fileName = file.name.split('.').slice(0, -1).join('.');

            // Update both the file and title in the form
            this.uploadForm.patchValue({
                file: file,
                title: fileName
            });
        }
    }

    loadDocuments() {
        this.instructorService.getDocuments(this.domainId).subscribe(
            documents => this.documents$.next(documents)
        );
    }

    onSubmit() {
        if (this.uploadForm.valid) {
            this.isUploading = true;
            const formData = new FormData();
            formData.append('domain', this.domainId.toString());
            Object.keys(this.uploadForm.value).forEach(key => {
                formData.append(key, this.uploadForm.value[key]);
            });

            this.instructorService.uploadDocument(formData).subscribe({
                next: () => {
                    this.uploadForm.reset();
                    this.loadDocuments();
                    this.isUploading = false;
                },
                error: () => {
                    this.isUploading = false;
                    // Handle error - you might want to add error messaging
                }
            });
        }
    }

    deleteDocument(id: number) {
        if (confirm('Are you sure you want to delete this document?')) {
            this.instructorService.deleteDocument(id).subscribe({
                next: () => this.loadDocuments()
            });
        }
    }

    goBack() {
        this.router.navigate(['/instructor/modules']);
    }
}
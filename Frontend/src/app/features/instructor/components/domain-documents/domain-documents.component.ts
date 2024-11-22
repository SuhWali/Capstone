import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { BehaviorSubject } from 'rxjs';
import { InstructorService } from '../../services/instructor.service'; // Adjust the path as necessary
import { Document } from '../../models/instructor.models'; // Adjust the path as necessary

@Component({
    selector: 'app-domain-documents',
    template: `
      <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <!-- Domain Selection -->
        <div class="mb-6">
          <label class="block text-sm font-medium text-gray-700">Select Domain</label>
          <select 
            [(ngModel)]="selectedDomainId"
            (change)="onDomainChange()"
            class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary sm:text-sm">
            <option [ngValue]="null">Select a domain</option>
            <option *ngFor="let domain of domains$ | async" [value]="domain.domainid">
              {{domain.domain_abb}} - {{domain.gradeid}}
            </option>
          </select>
        </div>
  
        <!-- Upload Form -->
        <div *ngIf="selectedDomainId" class="bg-white shadow sm:rounded-lg mb-6">
          <div class="px-4 py-5 sm:p-6">
            <h3 class="text-lg leading-6 font-medium text-gray-900">
              Upload New Document
            </h3>
            <form [formGroup]="uploadForm" (ngSubmit)="onSubmit()" class="mt-5">
              <div class="grid grid-cols-1 gap-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700">Title</label>
                  <input type="text" 
                         formControlName="title"
                         class="mt-1 block w-full shadow-sm sm:text-sm rounded-md">
                </div>
  
                <div>
                  <label class="block text-sm font-medium text-gray-700">Description</label>
                  <textarea 
                    formControlName="description"
                    rows="3"
                    class="mt-1 block w-full shadow-sm sm:text-sm rounded-md"></textarea>
                </div>
  
                <div>
                  <label class="block text-sm font-medium text-gray-700">File</label>
                  <input type="file" 
                         (change)="onFileChange($event)"
                         class="mt-1 block w-full shadow-sm sm:text-sm">
                </div>
  
                <div>
                  <button type="submit"
                          [disabled]="uploadForm.invalid || isUploading"
                          class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-primary hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">
                    <span *ngIf="isUploading">Uploading...</span>
                    <span *ngIf="!isUploading">Upload Document</span>
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
  
        <!-- Documents List -->
        <div class="bg-white shadow overflow-hidden sm:rounded-md">
          <ul class="divide-y divide-gray-200">
            <li *ngFor="let doc of documents$ | async">
              <div class="px-4 py-4 flex items-center sm:px-6">
                <div class="min-w-0 flex-1 sm:flex sm:items-center sm:justify-between">
                  <div>
                    <div class="flex text-sm">
                      <p class="font-medium text-primary truncate">{{doc.title}}</p>
                      <p class="ml-1 flex-shrink-0 font-normal text-gray-500">
                        in {{doc.domain_name}}
                      </p>
                    </div>
                    <div class="mt-2 flex">
                      <div class="flex items-center text-sm text-gray-500">
                        <p>
                          Uploaded {{doc.uploaded_at | date}} by {{doc.uploaded_by_name}}
                        </p>
                      </div>
                    </div>
                  </div>
                  <div class="mt-4 flex-shrink-0 sm:mt-0 sm:ml-5">
                    <button
                      (click)="deleteDocument(doc.id!)"
                      class="text-red-600 hover:text-red-900">
                      Delete
                    </button>
                  </div>
                </div>
              </div>
            </li>
          </ul>
        </div>
      </div>
    `
})

export class DomainDocumentsComponent implements OnInit {
    domains$ = this.instructorService.getMyDomains();
    documents$ = new BehaviorSubject<Document[]>([]);
    selectedDomainId: number | null = null;
    uploadForm: FormGroup;
    isUploading = false;

    constructor(
        private fb: FormBuilder,
        private instructorService: InstructorService
    ) {
        this.uploadForm = this.fb.group({
            title: ['', Validators.required],
            description: [''],
            domain: [null, Validators.required],
            file: [null, Validators.required]
        });
    }

    ngOnInit() {
        this.loadDocuments();
    }

    onDomainChange() {
        this.uploadForm.patchValue({ domain: this.selectedDomainId });
    }

    onFileChange(event: Event) {
        const file = (event.target as HTMLInputElement).files?.[0];
        this.uploadForm.patchValue({ file });
    }

    loadDocuments() {
        this.instructorService.getDocuments().subscribe(
            documents => this.documents$.next(documents)
        );
    }

    onSubmit() {
        if (this.uploadForm.valid) {
            this.isUploading = true;
            const formData = new FormData();
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
                    // Handle error
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
}

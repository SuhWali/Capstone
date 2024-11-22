import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';

import { SharedModule } from '../../shared/shared.module';
import { DashboardComponent } from './components/domain-documents/dashboard/dashboard.component';
import { InstructorRoutingModule } from './instructor-routing.module';
import { DomainDocumentsComponent } from './components/domain-documents/domain-documents.component'

import { FormsModule, ReactiveFormsModule } from '@angular/forms';


@NgModule({
  declarations: [
    DashboardComponent,
    DomainDocumentsComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    ReactiveFormsModule,
    InstructorRoutingModule,
    

  ]
})
export class InstructorModule { }

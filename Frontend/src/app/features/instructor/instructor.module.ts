import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';

import { SharedModule } from '../../shared/shared.module';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { GradeSelectionComponent } from './components/grade-selection/grade-selection.component'
import { DomainListComponent } from './components/domain-list/domain-list.component'
import { DocumentManagementComponent } from './components/documents/document-management.component'

// import { DomainDocumentsComponent } from './components/domain-documents/domain-documents.component';
import { InstructorRoutingModule } from './instructor-routing.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { InstructorService } from '../instructor/services/instructor.service';
import { ExerciseComponent } from './components/exercise/exercise.component';
import { DomainDetailComponent } from './components/domain-detail/domain-detail.component'

@NgModule({
  declarations: [
    DashboardComponent,
    GradeSelectionComponent,
    DomainListComponent,
    DocumentManagementComponent,
    ExerciseComponent,
    DomainDetailComponent

  ],
  imports: [
    CommonModule,
    SharedModule,
    FormsModule,
    ReactiveFormsModule,
    InstructorRoutingModule,

  ],
  providers: [InstructorService],

})
export class InstructorModule { }

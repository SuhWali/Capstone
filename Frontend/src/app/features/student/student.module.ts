import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';

import { DashboardComponent } from './components/dashboard/dashboard.component';
import { StudentRoutingModule } from './student-routing.module';

import { SharedModule } from '../../shared/shared.module';
import { EnrolledCoursesComponent } from './components/enrolled-courses/enrolled-courses.component';
import { CourseDomainsComponent } from './components/course-domains/course-domains.component';
import { DomainDetailComponent } from './components/domain-detail/domain-detail.component';


@NgModule({
  declarations: [
    DashboardComponent,
    EnrolledCoursesComponent,
    CourseDomainsComponent,
    DomainDetailComponent
  ],
  imports: [
    CommonModule,
    StudentRoutingModule,
    SharedModule
  ],
  exports: [
    DashboardComponent
  ]
})
export class StudentModule { }

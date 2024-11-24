import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { GradeSelectionComponent } from './components/grade-selection/grade-selection.component'
import { DomainListComponent } from './components/domain-list/domain-list.component'
import { DocumentManagementComponent } from './components/documents/document-management.component'


const routes: Routes = [
  {
      path: '',  // Important: Empty path
      component: DashboardComponent,
      children: [
        {
          path: 'grades',
          component: GradeSelectionComponent
        },
      
        {
          path: 'modules',
          component: DomainListComponent
        },
          {
            path: 'documents/:domainId',
            component: DocumentManagementComponent
          }
      ]
  }
];






@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class InstructorRoutingModule { }

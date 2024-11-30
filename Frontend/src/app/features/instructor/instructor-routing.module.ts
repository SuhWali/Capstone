import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { GradeSelectionComponent } from './components/grade-selection/grade-selection.component'
import { DomainListComponent } from './components/domain-list/domain-list.component'
import { DomainDetailComponent } from './components/domain-detail/domain-detail.component'


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
            path: 'domain/:domainId',
            component: DomainDetailComponent
          }
      ]
  }
];






@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class InstructorRoutingModule { }

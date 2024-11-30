import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { EnrolledCoursesComponent } from './components/enrolled-courses/enrolled-courses.component'
import { CourseDomainsComponent } from './components/course-domains/course-domains.component'
import { DomainDetailComponent } from './components/domain-detail/domain-detail.component'


const routes: Routes = [

  {
    path: "", component: DashboardComponent
  },
  {
    path: "course", component: EnrolledCoursesComponent
  },
  {
    path: "course-detail", component: CourseDomainsComponent
  },
  {
    path: "domain-detail/:id", component:DomainDetailComponent
  }

];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class StudentRoutingModule { }

import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {DashboardComponent} from './components/domain-documents/dashboard/dashboard.component'
import { DomainDocumentsComponent } from './components/domain-documents/domain-documents.component'

const routes: Routes = [

  {
  path:"dashboard",
  component:DashboardComponent,
  
  },
  {
  path:"domain",
  component:DomainDocumentsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class InstructorRoutingModule { }

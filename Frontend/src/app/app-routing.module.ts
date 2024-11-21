import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { LoginComponent } from './core/components/login/login.component'

import { MainLayoutComponent } from './shared/layouts/main-layout/main-layout.component';

import { AuthGuard } from './core/guards/auth.guard'
import { RoleGuard } from './core/guards/role.guard'
import { LoginGuard } from './core/guards/login.guard'

const routes: Routes = [

  {
    path: '',
    component: MainLayoutComponent,
    canActivate: [AuthGuard],
    children: [
      {
        path: 'student',
        loadChildren: () =>
          import('./features/student/student.module').then((m) => m.StudentModule),
        canActivate: [AuthGuard, RoleGuard],
        data: { role: 'student' }
      },
      {
        path: 'instructor',
        loadChildren: () =>
          import('./features/instructor/instructor.module').then((m) => m.InstructorModule),
        canActivate: [AuthGuard, RoleGuard],
        data: { role: 'instructor' }

      }
    ]
  },
  {
    path: 'login', component: LoginComponent,
    canActivate: [LoginGuard]
  },


];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }

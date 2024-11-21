import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { StudentModule } from './student/student.module'
import { InstructorModule } from './instructor/instructor.module'

// import {SharedModule} from '../shared/shared.module'


@NgModule({
  declarations: [],
  imports: [
    CommonModule,
    StudentModule,
    InstructorModule,
    // SharedModule
  ]
})
export class FeaturesModule { }

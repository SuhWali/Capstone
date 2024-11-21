import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';

import { CommonModule } from '@angular/common';
import {SharedModule} from '../shared/shared.module'

import { HomeComponent } from './components/home/home.component';
import { AboutComponent } from './components/about/about.component';
import {LoginComponent} from './components/login/login.component'


@NgModule({
  declarations: [

    HomeComponent,
    AboutComponent,
    LoginComponent
  ],
  imports: [
    CommonModule,
    SharedModule,
    ReactiveFormsModule
  ],
  exports: [
    HomeComponent,
    LoginComponent

    
  ]
})
export class CoreModule { }

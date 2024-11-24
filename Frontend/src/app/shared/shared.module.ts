import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';


import {AppAlertComponent} from './components/alert/alert.component'

import { MainLayoutComponent } from './layouts/main-layout/main-layout.component';
import { AppHeaderComponent } from './components/header/header.component';
import { FooterComponent } from './components/footer/footer.component';



@NgModule({
  declarations: [
    AppAlertComponent,
    MainLayoutComponent,
    AppHeaderComponent,
    FooterComponent],
  imports: [
    CommonModule,
    RouterModule
  ],
  exports: [
    AppAlertComponent,
    MainLayoutComponent,
    // AppHeaderComponent,
    // FooterComponent,

  ]
})
export class SharedModule { }

import { Component } from '@angular/core';

@Component({
    selector: 'app-main-layout',
    template: `
    <div class="min-h-screen flex flex-col">
      <app-header></app-header>
      <main class="flex-grow">
    <router-outlet></router-outlet>
      </main>
      <app-footer></app-footer>
    </div>
  `
})

export class MainLayoutComponent { }
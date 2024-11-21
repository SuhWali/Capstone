import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-alert',
  template: `
    <div *ngIf="message" 
         [ngClass]="{'bg-red-100 border-red-400 text-red-700': type === 'error',
                     'bg-green-100 border-green-400 text-green-700': type === 'success'}"
         class="border px-4 py-3 rounded relative mb-4" 
         role="alert">
      <span class="block sm:inline">{{message}}</span>
    </div>
  `
})
export class AppAlertComponent {
  @Input() message: string | null = null;
  @Input() type: 'error' | 'success' = 'error';
}
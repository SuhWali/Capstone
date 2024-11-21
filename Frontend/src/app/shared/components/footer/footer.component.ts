import { Component } from '@angular/core';

@Component({
    selector: 'app-footer',
    template: `
      <footer class="bg-white border-t border-gray-200">
        <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <p class="text-gray-500 text-sm">
              © {{currentYear}} Your App Name. All rights reserved.
            </p>
          </div>
        </div>
      </footer>
    `
})
export class FooterComponent {
    currentYear = new Date().getFullYear();
}
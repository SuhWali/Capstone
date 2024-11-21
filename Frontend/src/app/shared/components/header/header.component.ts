import { Component } from '@angular/core';
import { Store } from '@ngrx/store';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { AuthState } from '../../../core/models/user.model';

@Component({
    selector: 'app-header',
    template: `
    <header class="bg-white shadow">
      <nav class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <!-- Logo -->
          <div class="flex-shrink-0 flex items-center">
            <img class="h-8 w-auto" src="logo.jpg" alt="Logo">
          </div>

          <!-- Navigation -->
          <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
            <!-- Student Navigation -->
            <ng-container *ngIf="(userRoles$ | async)?.includes('student')">
              <a routerLink="/student/dashboard" 
                 routerLinkActive="border-primary text-gray-900"
                 class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                Dashboard
              </a>
              <a routerLink="/student/courses" 
                 routerLinkActive="border-primary text-gray-900"
                 class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                Courses
              </a>
              <a routerLink="/student/assignments" 
                 routerLinkActive="border-primary text-gray-900"
                 class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                Assignments
              </a>
            </ng-container>

            <!-- Instructor Navigation -->
            <ng-container *ngIf="(userRoles$ | async)?.includes('instructor')">
              <a routerLink="/instructor/dashboard" 
                 routerLinkActive="border-primary text-gray-900"
                 class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                Dashboard
              </a>
              <a routerLink="/instructor/courses" 
                 routerLinkActive="border-primary text-gray-900"
                 class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                Manage Courses
              </a>
              <a routerLink="/instructor/students" 
                 routerLinkActive="border-primary text-gray-900"
                 class="border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium">
                Students
              </a>
            </ng-container>
          </div>

          <!-- Profile Dropdown -->
          <div class="hidden sm:ml-6 sm:flex sm:items-center">
            <div class="ml-3 relative">
              <button (click)="toggleProfileMenu()" 
                      class="flex text-sm rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">
                <span class="sr-only">Open user menu</span>
                <div class="h-8 w-8 rounded-full bg-gray-200 flex items-center justify-center">
                  <span class="text-sm font-medium text-gray-600">{{getInitials()}}</span>
                </div>
              </button>

              <!-- Dropdown menu -->
              <div *ngIf="showProfileMenu" 
                   class="origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5 focus:outline-none">
                <a routerLink="/profile" 
                   class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                  Your Profile
                </a>
                <button (click)="logout()" 
                        class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                  Sign out
                </button>
              </div>
            </div>
          </div>

          <!-- Mobile menu button -->
          <div class="sm:hidden">
            <button (click)="toggleMobileMenu()" 
                    class="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-primary">
              <span class="sr-only">Open main menu</span>
              <svg *ngIf="!showMobileMenu" class="block h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
              </svg>
              <svg *ngIf="showMobileMenu" class="block h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        </div>

        <!-- Mobile menu -->
        <div *ngIf="showMobileMenu" class="sm:hidden">
          <div class="pt-2 pb-3 space-y-1">
            <!-- Student Mobile Navigation -->
            <ng-container *ngIf="(userRoles$ | async)?.includes('student')">
              <a routerLink="/student/dashboard" 
                 routerLinkActive="bg-primary text-white"
                 class="text-gray-600 hover:bg-gray-50 hover:text-gray-900 block pl-3 pr-4 py-2 border-l-4 text-base font-medium">
                Dashboard
              </a>
              <a routerLink="/student/courses" 
                 routerLinkActive="bg-primary text-white"
                 class="text-gray-600 hover:bg-gray-50 hover:text-gray-900 block pl-3 pr-4 py-2 border-l-4 text-base font-medium">
                Courses
              </a>
              <a routerLink="/student/assignments" 
                 routerLinkActive="bg-primary text-white"
                 class="text-gray-600 hover:bg-gray-50 hover:text-gray-900 block pl-3 pr-4 py-2 border-l-4 text-base font-medium">
                Assignments
              </a>
            </ng-container>

            <!-- Instructor Mobile Navigation -->
            <ng-container *ngIf="(userRoles$ | async)?.includes('instructor')">
              <a routerLink="/instructor/dashboard" 
                 routerLinkActive="bg-primary text-white"
                 class="text-gray-600 hover:bg-gray-50 hover:text-gray-900 block pl-3 pr-4 py-2 border-l-4 text-base font-medium">
                Dashboard
              </a>
              <a routerLink="/instructor/courses" 
                 routerLinkActive="bg-primary text-white"
                 class="text-gray-600 hover:bg-gray-50 hover:text-gray-900 block pl-3 pr-4 py-2 border-l-4 text-base font-medium">
                Manage Courses
              </a>
              <a routerLink="/instructor/students" 
                 routerLinkActive="bg-primary text-white"
                 class="text-gray-600 hover:bg-gray-50 hover:text-gray-900 block pl-3 pr-4 py-2 border-l-4 text-base font-medium">
                Students
              </a>
            </ng-container>
          </div>
        </div>
      </nav>
    </header>
  `
})

export class AppHeaderComponent {
    showProfileMenu = false;
    showMobileMenu = false;
    userRoles$ = this.store.select(state => state.auth.roles);

    constructor(
        private store: Store<{ auth: AuthState }>,
        private router: Router
    ) { }

    toggleProfileMenu() {
        this.showProfileMenu = !this.showProfileMenu;
    }

    toggleMobileMenu() {
        this.showMobileMenu = !this.showMobileMenu;
    }

    getInitials(): string {
        // Implement based on your user data
        return 'U';
    }

    logout() {
        // Implement logout logic
    }
}
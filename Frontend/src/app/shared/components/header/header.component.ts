import { Component } from '@angular/core';
import { Store } from '@ngrx/store';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { AuthState } from '../../../core/models/user.model';
import * as AuthActions from '../../../core/store/auth/auth.actions';


@Component({
    selector: 'app-header',
    templateUrl:'./header.component.html'
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
      this.store.dispatch(AuthActions.logout());
        
    }
}
import { Injectable } from '@angular/core';
import { CanActivate, Router, UrlTree } from '@angular/router';
import { Store } from '@ngrx/store';
import { Observable, filter, switchMap } from 'rxjs';
import { map } from 'rxjs/operators';
import { AuthState } from '../models/user.model';
import { selectIsAuthenticated, selectIsInitialized } from '../store/auth/auth.selectors'




@Injectable({
    providedIn: 'root'
})
export class AuthGuard implements CanActivate {
    constructor(
        private store: Store<{ auth: AuthState }>,
        private router: Router
    ) { }

    canActivate(): Observable<boolean | UrlTree> {
        return this.store.select(selectIsInitialized).pipe(
            filter(loading => !loading), // Wait for initialization
            switchMap(() => this.store.select(selectIsAuthenticated)),
            map(isAuthenticated => {
                if (!isAuthenticated) {
                    return this.router.createUrlTree(['/login']);
                }
                return true;
            })
        );
    }
}
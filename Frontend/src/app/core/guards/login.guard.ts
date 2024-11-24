// guards/login.guard.ts
import { Injectable } from '@angular/core';
import { CanActivate, Router, UrlTree } from '@angular/router';
import { Store } from '@ngrx/store';
import { Observable, filter, switchMap } from 'rxjs';
import { map, withLatestFrom } from 'rxjs/operators';
import { AuthState } from '../models/user.model';
import { selectIsAuthenticated, selectUserRoles, selectIsInitialized } from '../store/auth/auth.selectors'


@Injectable({
  providedIn: 'root'
})
export class LoginGuard implements CanActivate {
  constructor(
    private store: Store<{ auth: AuthState }>,
    private router: Router
  ) {}

  canActivate(): Observable<boolean | UrlTree> {
    return this.store.select(selectIsInitialized).pipe(
      filter(loading => !loading), // Wait for initialization
      switchMap(() => this.store.select(selectIsAuthenticated).pipe(
        withLatestFrom(this.store.select(selectUserRoles)),
        map(([isAuthenticated, roles]) => {
          if (isAuthenticated) {
            if (roles && roles.length > 0) {
              return this.router.createUrlTree([`/${roles[0].toLowerCase()}`]);
            }
            return this.router.createUrlTree(['/']);
          }
          return true;
        })
      ))
    );
  }
}
import { Injectable } from '@angular/core';
import { CanActivate, Router, UrlTree } from '@angular/router';
import { Store } from '@ngrx/store';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { AuthState } from '../models/user.model';

@Injectable({
    providedIn: 'root'
})
export class AuthGuard implements CanActivate {
    constructor(
        private store: Store<{ auth: AuthState }>,
        private router: Router
    ) { }

    canActivate(): Observable<boolean | UrlTree> {
        return this.store.select(state => state.auth.token).pipe(
            map(token => {
                if (token) {
                    // console.log(token,"tokenn")
                    return true;
                }
                return this.router.createUrlTree(['/login']);
            })
        );
    }
}

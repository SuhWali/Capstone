import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Store } from '@ngrx/store';
import * as AuthActions from '../../store/auth/auth.actions';
import { AuthState } from '../../models/user.model';


@Component({
    selector: 'app-login',
    templateUrl: 'login.component.html',
    // styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
    loginForm: FormGroup;
    loading$ = this.store.select(state => state.auth.loading);
    error$ = this.store.select(state => state.auth.error);


    constructor(
        private fb: FormBuilder,
        private store: Store<{ auth: AuthState }>
    ) {

        this.loginForm = this.fb.group({
            username: ['', [Validators.required, Validators.minLength(6)]],
            password: ['', [Validators.required, Validators.minLength(6)]]
        });
    }

    ngOnInit(): void {
    }

    isFieldInvalid(field: string): boolean {
        const formField = this.loginForm.get(field);
        return formField ? (formField.invalid && formField.touched) : false;
    }

    onSubmit(): void {
        if (this.loginForm.valid) {
            const { username, password } = this.loginForm.value;
            this.store.dispatch(AuthActions.login({ username, password }));
        } else {
            Object.keys(this.loginForm.controls).forEach(key => {
                const control = this.loginForm.get(key);
                if (control?.invalid) {
                    control.markAsTouched();
                }
            });
        }
    }
}
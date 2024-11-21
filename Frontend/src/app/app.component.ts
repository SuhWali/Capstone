import { Component, OnInit } from '@angular/core';
import { Store } from '@ngrx/store';
import * as AuthActions from './core/store/auth/auth.actions';

// give helper function for fetching data 

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent implements OnInit{
  title = 'Frontend Suhayb';
  constructor(private store: Store) {}

  ngOnInit() {
    this.store.dispatch(AuthActions.initializeAuth());
  }
}

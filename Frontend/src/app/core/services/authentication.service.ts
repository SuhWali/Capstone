import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { TokenResponse, UserRoles } from '../models/user.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  constructor(private http: HttpClient) {}

  login(username: string, password: string): Observable<TokenResponse> {
    return this.http.post<TokenResponse>(`${environment.apiUrl}/api/token/`, { username, password });
  }

  getUserRoles(): Observable<UserRoles> {
    return this.http.get<UserRoles>(`${environment.apiUrl}/user-roles/`);
  }

  logout(): Observable<void> {
    return this.http.post<void>(`${environment.apiUrl}/auth/logout/`, {});
  }

  refreshToken(): Observable<{ token: string }> {
    return this.http.post<{ token: string }>(`${environment.apiUrl}/api/token/refresh`, {});
  }
}
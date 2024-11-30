import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Observable } from 'rxjs';
import { InstructorService } from '../../services/instructor.service';
import { Domain } from '../../models/instructor.models';


@Component({
  selector: 'app-domain-detail',
  templateUrl: './domain-detail.component.html'
})
export class DomainDetailComponent implements OnInit {
  currentDomain$: Observable<Domain> = new Observable();
  activeTab = 'documents';
  tabs = [
    { id: 'documents', name: 'Documents' },
    { id: 'exercises', name: 'Exercises' }
  ];
  domainId: number = 0;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private instructorService: InstructorService
  ) {}

  ngOnInit() {
    this.route.params.subscribe(params => {
      this.domainId = +params['domainId'];
      this.currentDomain$ = this.instructorService.getDomain(this.domainId);
    });
  }

  setActiveTab(tabId: string) {
    this.activeTab = tabId;
  }

  goBack() {
    this.router.navigate(['/instructor/modules']);
  }
}
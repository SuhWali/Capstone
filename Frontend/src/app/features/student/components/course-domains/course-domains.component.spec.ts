import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CourseDomainsComponent } from './course-domains.component';

describe('CourseDomainsComponent', () => {
  let component: CourseDomainsComponent;
  let fixture: ComponentFixture<CourseDomainsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [CourseDomainsComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CourseDomainsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

package com.flynn.schooldb.repository;

import com.flynn.schooldb.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {

    List<Student> findAll();
    Optional<Student> findByOhioSsid(String ohioSsid);
    List<Student> findByFirstNameIgnoreCase(String firstName);
    List<Student> findByLastNameIgnoreCase(String lastName);
    List<Student> findByMiddleNameIgnoreCase(String middleName);
    List<Student> findByFirstNameIgnoreCaseAndLastNameIgnoreCase(String firstName, String lastName);
    List<Student> findByFirstNameIgnoreCaseOrMiddleNameIgnoreCaseOrLastNameIgnoreCase(String firstName, String middleName, String lastName);
    @Query("SELECT s FROM Student s WHERE s.email LIKE %?1% OR s.firstName LIKE %?1% OR s.lastName LIKE %?1%")
    List<Student> searchByKeyword(String keyword);
    Optional<Student> findByEmail(String email);
    List<Student> findByDob(LocalDate dob);
    List<Student> findByDobBefore(LocalDate date);
    List<Student> findByDobAfter(LocalDate date);
    List<Student> findBySex(Character sex);
    List<Student> findByDobBetween(LocalDate startDate, LocalDate endDate);
    List<Student> findByLastNameOrderByFirstNameAsc(String lastName);
    long countBySex(Character sex);
    long countByDob(LocalDate dob);
    List<Student> findBySexOrderByLastNameAsc(Character sex);
    List<Student> findByEmailContainingIgnoreCase(String emailFragment);

}

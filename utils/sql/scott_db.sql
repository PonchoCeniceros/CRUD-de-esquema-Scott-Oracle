drop table emp;
drop table dept;

create table dept(
	deptno number(2) not null,
	dname varchar2(14) not null,
	loc varchar2(13) not null
);

alter table dept add constraint pk_deptno primary key (deptno);

create table emp(
	empno number(4) not null,
	ename varchar2(10) not null,
	job varchar2(9) not null,
	mgr number(4),
	hiredate date not null,
	sal number(7, 2) not null,
	comm number(7, 2),
	deptno number(2) not null
);

alter table emp add constraint pk_empno primary key (empno);
alter table emp add constraint fk_emp_dept foreign key (deptno) references dept(deptno) on delete cascade;

-- Procedimientos y Funciones Almacenados:
create or replace package pkg_scott as
    -- * Add_depto()
    procedure Add_depto(
        p_deptno dept.deptno%TYPE,
        p_dname dept.dname%TYPE,
        p_loc dept.loc%TYPE
    );
    -- * Update_depto()
    procedure Update_depto(
        p_deptno dept.deptno%TYPE,
        p_dname dept.dname%TYPE,
        p_loc dept.loc%TYPE
    );
    
    -- * Delete_depto()
    procedure Delete_depto(
        p_deptno dept.deptno%TYPE
    );

    -- * Add_emp()
    procedure Add_emp(
        p_empno emp.empno%TYPE,
        p_ename emp.ename%TYPE,
        p_job emp.job%TYPE,
        p_mgr emp.mgr%TYPE,
        p_hiredate emp.hiredate%TYPE,
        p_sal emp.sal%TYPE,
        p_comm emp.comm%TYPE,
        p_deptno emp.deptno%TYPE
    );
    
    -- * Delete_emp()
    procedure Delete_emp(
        p_empno emp.empno%TYPE
    );
    
    -- * Update_emp()
    procedure Update_emp(
        p_empno emp.empno%TYPE,
        p_ename emp.ename%TYPE,
        p_job emp.job%TYPE,
        p_mgr emp.mgr%TYPE,
        p_hiredate emp.hiredate%TYPE,
        p_sal emp.sal%TYPE,
        p_comm emp.comm%TYPE,
        p_deptno emp.deptno%TYPE
    );
    
    -- * noEmp_depto()
    function noEmp_depto(
        p_deptno emp.deptno%TYPE
    ) return number;
    
end pkg_scott;

create or replace package body pkg_scott as
    -- * Add_depto()
    procedure Add_depto(
        p_deptno dept.deptno%TYPE,
        p_dname dept.dname%TYPE,
        p_loc dept.loc%TYPE
    )
    is
        nnl_exception exception;
        pragma exception_init(nnl_exception, -01400);
    begin
        insert into dept values(p_deptno, p_dname, p_loc);
        commit;
        dbms_output.put_line('depto ' || p_deptno || ' insertado');
    exception
        when nnl_exception then
            raise_application_error(-20200, 'se requiere insertar todos los datos');
    end;
    
    -- * Update_depto()
    procedure Update_depto(
        p_deptno dept.deptno%TYPE,
        p_dname dept.dname%TYPE,
        p_loc dept.loc%TYPE
    )
    is
    begin
        update dept set dname = p_dname, loc = p_loc where deptno = p_deptno;
        commit;
        dbms_output.put_line('depto ' || p_deptno || ' actualizado');
    end;
    
    -- * Delete_depto()
    procedure Delete_depto(p_deptno dept.deptno%TYPE)
    is
    begin
        delete dept where deptno = p_deptno;
        commit;
        dbms_output.put_line('depto ' || p_deptno || ' eliminado junto a sus empleados');
    end;

    -- * Add_emp()
    procedure Add_emp(
        p_empno emp.empno%TYPE,
        p_ename emp.ename%TYPE,
        p_job emp.job%TYPE,
        p_mgr emp.mgr%TYPE,
        p_hiredate emp.hiredate%TYPE,
        p_sal emp.sal%TYPE,
        p_comm emp.comm%TYPE,
        p_deptno emp.deptno%TYPE
    )
    is
        nnl_exception exception;
        pragma exception_init(nnl_exception, -01400);
    begin
        insert into emp values(p_empno, p_ename, p_job, p_mgr, p_hiredate, p_sal, p_comm, p_deptno);
        commit;
        dbms_output.put_line('empleado ' || p_empno || ' insertado');
    exception
        when nnl_exception then
            raise_application_error(-20200, 'se requiere insertar todos los datos');
    end;
    
    -- * Delete_emp()
    procedure Delete_emp(p_empno emp.empno%TYPE)
    is
    begin
        delete emp where empno = p_empno;
        commit;
        dbms_output.put_line('empleado ' || p_empno || ' eliminado');
    end;
    
    -- * Update_emp()
    procedure Update_emp(
        p_empno emp.empno%TYPE,
        p_ename emp.ename%TYPE,
        p_job emp.job%TYPE,
        p_mgr emp.mgr%TYPE,
        p_hiredate emp.hiredate%TYPE,
        p_sal emp.sal%TYPE,
        p_comm emp.comm%TYPE,
        p_deptno emp.deptno%TYPE
    )
    is
    begin
        update emp
        set ename = p_ename, job = p_job, mgr = p_mgr, hiredate = p_hiredate, sal = p_sal, comm = p_comm, deptno = p_deptno
        where empno = p_empno;
        commit;
        dbms_output.put_line('empleado ' || p_empno || ' actualizado');
    end;

    -- * noEmp_depto()
    function noEmp_depto(p_deptno emp.deptno%TYPE) return number
    is
        count_emp number := 0;
    begin
        select count(empno) into count_emp from emp where deptno = p_deptno; 
        return count_emp;
    end;
    
end pkg_scott;

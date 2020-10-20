import cx_Oracle


class Database:
    def __enter__(self):
        self._conn = cx_Oracle.connect('SCOTT/TIGER@localhost:1521/xe')
        self._cursor = self._conn.cursor()
        return self

    def __exit__(self, type, value, traceback):
        self._cursor.close()
        self._conn.close()

    def add_dept(self, deptno, dname, loc):
        self._cursor.callproc("pkg_scott.Add_depto", [deptno, dname, loc])

    def update_dept(self, deptno, dname, loc):
        self._cursor.callproc("pkg_scott.Update_depto", [deptno, dname, loc])

    def delete_dept(self, deptno):
        self._cursor.callproc("pkg_scott.Delete_depto", [deptno])

    def add_emp(self, empno, ename, job, mgr, hiredate, sal, comm, deptno):
        self._cursor.callproc(
            "pkg_scott.Add_emp",
            [empno, ename, job, mgr, hiredate, sal, comm, deptno])

    def update_emp(self, empno, ename, job, mgr, hiredate, sal, comm, deptno):
        self._cursor.callproc(
            "pkg_scott.Update_emp",
            [empno, ename, job, mgr, hiredate, sal, comm, deptno])

    def delete_emp(self, empno):
        self._cursor.callproc("pkg_scott.Delete_emp", [empno])

    def noEmp_depto(self, deptno):
        count_emp = self._cursor.callfunc("pkg_scott.noEmp_depto", int,
                                          [deptno])
        return count_emp

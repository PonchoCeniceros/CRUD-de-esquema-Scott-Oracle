from app import app
from utils import scott
from flask import render_template, request
from datetime import datetime


@app.route("/")
def index():
    return render_template('index-dept.html')


@app.route("/emp/")
def index_emp():
    return render_template('index-emp.html')


@app.route("/show_dept/")
def show_depts():
    rows = list()
    with scott.Database() as db:
        for row in db._cursor.execute("select * from dept"):
            rows.append(row)
    return render_template('show-depts.html', rows=rows)


@app.route("/show_emps/")
def show_emps():
    rows = list()
    with scott.Database() as db:
        for row in db._cursor.execute("select * from emp"):
            rows.append(row)
    return render_template('show-emps.html', rows=rows)


@app.route('/insert_update_dept/', methods=['POST'])
def insert_update_dept():

    with scott.Database() as db:
        if request.form.get('insert_depto_bttn', '') != '':
            db.add_dept(request.form.get('deptno', 'null'),
                        request.form.get('dname', 'null'),
                        request.form.get('loc', 'null'))
        elif request.form.get('update_depto_bttn', '') != '':
            db.update_dept(request.form.get('deptno', 'null'),
                           request.form.get('dname', 'null'),
                           request.form.get('loc', 'null'))
    return render_template('op-done.html')


@app.route('/delete_dept/', methods=['POST'])
def delete_dept():
    with scott.Database() as db:
        db.delete_dept(request.form.get('deptno'))
    return render_template('op-done.html')


@app.route('/insert_update_emp/', methods=['POST'])
def insert_update_emp():
    with scott.Database() as db:
        if request.form.get('insert_emp_bttn', '') != '':
            hiredate = 'null' if (date := request.form.get('hiredate')
                                  ) == 0 else datetime.strptime(
                                      date + ' 00:00:00', "%Y-%m-%d %H:%M:%S")
            db.add_emp(request.form.get('empno', 'null'),
                       request.form.get('ename', 'null'),
                       request.form.get('job', 'null'),
                       request.form.get('mgr', 'None'), hiredate,
                       request.form.get('sal', 'null'),
                       request.form.get('comm', 'None'),
                       request.form.get('deptno', 'null'))
        elif request.form.get('update_emp_bttn', '') != '':
            hiredate = 'null' if (date := request.form.get('hiredate')
                                  ) == 0 else datetime.strptime(
                                      date + ' 00:00:00', "%Y-%m-%d %H:%M:%S")
            db.update_emp(request.form.get('empno', 'null'),
                          request.form.get('ename', 'null'),
                          request.form.get('job', 'null'),
                          request.form.get('mgr', 'None'), hiredate,
                          request.form.get('sal', 'null'),
                          request.form.get('comm', 'None'),
                          request.form.get('deptno', 'null'))
    return render_template('emp-op-done.html')


@app.route('/delete_emp/', methods=['POST'])
def delete_emp():
    with scott.Database() as db:
        db.delete_emp(request.form.get('empno'))
    return render_template('emp-op-done.html')


@app.route('/noEmp_depto/', methods=['POST'])
def noEmp_depto():
    with scott.Database() as db:
        deptno = request.form.get('deptno')
        ans = "El depto {} tiene {} empleados".format(deptno,
                                                      db.noEmp_depto(deptno))
    return render_template('noEmp_depto.html', ans=ans)

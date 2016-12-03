<?php

use App\Task;
use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

Route::get('/', function () {
	return view('tasks', [
		'tasks' => Task::orderBy('created_at', 'asc')->get()
	]);
});

Route::get('/hello', function () {
    return "<h1>It's Working</h1>";
});

/**
 * New Task
 */
Route::post('/task', 'TaskController@newTask');

/**
 * Delete An Existing Task
 */
Route::delete('/task/{id}', function ($id) {
	Task::findOrFail($id)->delete();
	return redirect('/');
});
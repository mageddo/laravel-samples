<?php
namespace App\Http\Controllers;

use App\User;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Validator;
use App\Task;

class TaskController extends Controller {

	public function newTask(Request $request){

		$validator = Validator::make($request->all(), [
				'name' => 'required|max:255',
		]);
		if ($validator->fails()) {
				return redirect('/')
						->withInput()
						->withErrors($validator);
		}
		$task = new Task;
		$task->name = $request->name;
		$task->save();
		return redirect('/');
	}

}
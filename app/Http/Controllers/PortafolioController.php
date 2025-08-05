<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Proyecto; 

class PortafolioController extends Controller
{
    public function index()
    {
        $proyectos = Proyecto::all();
        return view('portafolio', compact('proyectos'));
    }
}

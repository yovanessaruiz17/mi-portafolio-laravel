<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\PortafolioController;
use App\Http\Controllers\ContactoController;

Route::get('/', [PortafolioController::class, 'index']);

Route::post('/contacto', [ContactoController::class, 'enviar'])->name('contacto.enviar');

Route::get('/welcome', function () {
    return view('welcome');
});

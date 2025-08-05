<?php

namespace App\Http\Controllers;

use App\Models\Contacto;
use Illuminate\Http\Request;
use App\Mail\ContactoRecibidoMail;
use Illuminate\Support\Facades\Mail;


class ContactoController extends Controller
{
    public function enviar(Request $request)
{
    $request->validate([
        'nombre' => 'required',
        'email' => 'required|email',
        'mensaje' => 'required',
    ]);

    // Guardar en base de datos
    Contacto::create($request->all());

    // Comentado el envío de correo
    // Mail::to('tucorreo@ejemplo.com')->send(new ContactoRecibidoMail($request->all()));

    return redirect()->back()->with('success', 'Tu mensaje fue enviado correctamente');
}

}

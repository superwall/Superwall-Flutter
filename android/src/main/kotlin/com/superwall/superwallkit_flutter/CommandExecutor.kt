package com.superwall.superwallkit_flutter

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class Command<T : CommandArguments>(
    val name: String,
    val type: String,
    val handler: suspend (T) -> Unit
)

class Executor(val scope: CoroutineScope = CoroutineScope(Dispatchers.Main)) {
    val commands = mutableMapOf<String, Command<*>>()

    /** DSL function to register a command.
     * @T - arguments for the command
     * @name - name for the method call to handle
     * @handler - command to execute with arguments
     */
    inline fun <reified T : CommandArguments> command(
        name: String,
        noinline handler: suspend (T) -> Unit
    ) {
        // Get the type identifier for the CommandArguments class
        val type = CommandArgumentType.typeOf(T::class)
        commands[name] = Command(name, type, handler)
    }

    // Call the registered command by name.
    fun call(name: String, args: Map<String, Any>) {
        val command = commands[name] as? Command<CommandArguments>
            ?: throw IllegalArgumentException("No command registered with name: $name")

        // Convert the args to the appropriate CommandArguments type
        val commandArgs = CommandArguments.fromJson(args, command.type)

        // Invoke the handler.
        scope.launch {
            @Suppress("UNCHECKED_CAST")
            command.handler.invoke(commandArgs)
        }
    }
}

// A helper function to build an executor using a DSL.
fun executor(build: Executor.() -> Unit): Executor = Executor().apply(build)

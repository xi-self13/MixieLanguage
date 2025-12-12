
const vscode = require('vscode');
const { exec } = require('child_process');

function activate(context) {
    let disposable = vscode.commands.registerCommand('mixie.runFile', function () {
        const editor = vscode.window.activeTextEditor;
        if (editor) {
            const filePath = editor.document.fileName;
            const outputChannel = vscode.window.createOutputChannel("Mixie Output");

            // We need to get the workspace folder to find our interpreter.
            const workspaceFolder = vscode.workspace.workspaceFolders[0].uri.fsPath;

            // The interpreter is in the `.bin` directory at the root of the workspace.
            const command = `${workspaceFolder}/.bin/mixie-interpreter ${filePath}`;

            outputChannel.show();
            outputChannel.appendLine(`Running: ${command}`);

            exec(command, (err, stdout, stderr) => {
                if (err) {
                    outputChannel.appendLine(`Error: ${err.message}`);
                    return;
                }
                if (stderr) {
                    output_channel.appendLine(`Stderr: ${stderr}`);
                    return;
                }
                outputChannel.appendLine(stdout);
            });
        }
    });

    context.subscriptions.push(disposable);
}

function deactivate() {}

module.exports = {
    activate,
    deactivate
}

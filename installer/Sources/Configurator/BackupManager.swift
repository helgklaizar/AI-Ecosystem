import Foundation

class BackupManager {
    static let shared = BackupManager()
    
    func createBackup(in workspacePath: String, logs: inout String) {
        let workspaceURL = URL(fileURLWithPath: workspacePath)
        let agentsURL = workspaceURL.appendingPathComponent(".gemini/agents")
        let workflowsURL = workspaceURL.appendingPathComponent("workflows")
        
        let fileManager = FileManager.default
        
        // Only backup if there's actually something to backup
        let hasAgents = fileManager.fileExists(atPath: agentsURL.path)
        let hasWorkflows = fileManager.fileExists(atPath: workflowsURL.path)
        
        guard hasAgents || hasWorkflows else {
            logs += "ℹ️ No existing configurations found. Skipping backup.\n"
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = dateFormatter.string(from: Date())
        
        let backupFolderName = "_legacy_backup_\(timestamp)"
        let backupURL = workspaceURL.appendingPathComponent(backupFolderName)
        
        do {
            try fileManager.createDirectory(at: backupURL, withIntermediateDirectories: true)
            logs += "📦 Created backup folder: \(backupFolderName)\n"
            
            var backedUpItems = [String]()
            
            if hasAgents {
                let dest = backupURL.appendingPathComponent("agents")
                try fileManager.moveItem(at: agentsURL, to: dest)
                backedUpItems.append("Agents Directory")
            }
            
            if hasWorkflows {
                let dest = backupURL.appendingPathComponent("workflows")
                try fileManager.moveItem(at: workflowsURL, to: dest)
                backedUpItems.append("Workflows Directory")
            }
            
            // Create a migration log MD file
            let mdContent = """
            # System Backup
            
            **Date:** \(Date().description)
            
            ## What happened?
            You installed a new Configurator Profile. To prevent your existing tools and custom configurations from being overwritten or lost, the system automatically moved them to this legacy backup folder.
            
            ## Items Backed Up:
            \(backedUpItems.map { "- \($0)" }.joined(separator: "\n"))
            
            ## Why is this here?
            This ensures your previous context, local memory, and custom agents are safe. You can safely copy code snippets or old memory files from this folder into your new workspace setup if needed.
            """
            
            let mdURL = backupURL.appendingPathComponent("migration_log.md")
            try mdContent.write(to: mdURL, atomically: true, encoding: .utf8)
            
            logs += "✅ Successfully backed up existing configs to \(backupFolderName)\n"
            
        } catch {
            logs += "⚠️ Warning: Failed to create backup. Error: \(error.localizedDescription)\n"
        }
    }
}

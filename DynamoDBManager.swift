import Foundation
import AWSDynamoDB
import AWSClientRuntime

struct AWSConfig {
    static let region = "us-east-1" // Change to your AWS region
    static let accessKey = ProcessInfo.processInfo.environment["AWS_ACCESS_KEY_ID"] ?? ""
    static let secretKey = ProcessInfo.processInfo.environment["AWS_SECRET_ACCESS_KEY"] ?? ""
}

struct PatientData: Codable {
    let patientID: String
    let dataType: String
    let timestamp: String
    let additionalInfo: String?
}

class DynamoDBManager {
    private let client: DynamoDBClient

    init() {
        do {
            let credentialsProvider = try StaticCredentialProvider(
                accessKey: AWSConfig.accessKey,
                secret: AWSConfig.secretKey
            )
            let config = try DynamoDBClient.Configuration(
                region: AWSConfig.region,
                credentialsProvider: credentialsProvider
            )
            client = DynamoDBClient(config: config)
            print("DynamoDB initialized successfully with environment credentials")
        } catch {
            fatalError("Failed to initialize DynamoDB: \(error)")
        }
    }

    /// Save patient data to DynamoDB
    func savePatientData(_ data: PatientData) async {
        let item: [String: DynamoDBClientTypes.AttributeValue] = [
            "PatientID": .s(data.patientID),
            "dataType#timestamp": .s("\(data.dataType)#\(data.timestamp)"),
            "additionalInfo": data.additionalInfo != nil ? .s(data.additionalInfo!) : .null(true)
        ]

        let input = PutItemInput(tableName: "PatientData", item: item)

        do {
            _ = try await client.putItem(input: input)
            print("Data saved successfully!")
        } catch {
            print("Error saving data: \(error)")
        }
    }

    /// Fetch patient data from DynamoDB
    func fetchPatientData(patientID: String) async -> [PatientData]? {
        let key: [String: DynamoDBClientTypes.AttributeValue] = [
            "PatientID": .s(patientID)
        ]

        let input = QueryInput(
            tableName: "PatientData",
            keyConditionExpression: "PatientID = :patientID",
            expressionAttributeValues: [":patientID": .s(patientID)]
        )

        do {
            let output = try await client.query(input: input)
            return output.items?.compactMap { item in
                guard let patientID = item["PatientID"]?.s,
                      let dataTypeTimestamp = item["dataType#timestamp"]?.s else {
                    return nil
                }
                
                let components = dataTypeTimestamp.split(separator: "#")
                let dataType = String(components.first ?? "")
                let timestamp = String(components.last ?? "")
                let additionalInfo = item["additionalInfo"]?.s

                return PatientData(patientID: patientID, dataType: dataType, timestamp: timestamp, additionalInfo: additionalInfo)
            }
        } catch {
            print("Error fetching data: \(error)")
            return nil
        }
    }
}

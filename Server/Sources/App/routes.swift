import ScreenData
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: ScreenController())
}

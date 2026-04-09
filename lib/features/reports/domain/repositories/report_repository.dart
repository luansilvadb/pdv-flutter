import '../entities/report.dart';

abstract class ReportRepository {
  Future<Report> generateSalesReport(DateTime start, DateTime end);
  Future<Report> generateProductsReport(DateTime start, DateTime end);
  Future<Report> generateFinancialReport(DateTime start, DateTime end);
}

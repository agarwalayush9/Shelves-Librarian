//
//  Graphs.swift
//  Shlves-Library
//
//  Created by Abhay singh on 15/07/24.
//

import SwiftUI
import Charts

//MARK: for event revenue  data
struct eventRevenueData: Identifiable {
    var id = UUID()
    var date: Date
    var ticketCount: Int
    var ticketPrice: Int
}

class eventRevenueViewModel: ObservableObject {
    @Published var events = [eventRevenueData]()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        // Generate sample data
        events = [
            eventRevenueData(date: Date(), ticketCount: 100, ticketPrice: 50),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, ticketCount: 150, ticketPrice: 60),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, ticketCount: 200, ticketPrice: 70),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!, ticketCount: 120, ticketPrice: 55),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!, ticketCount: 180, ticketPrice: 65)
        ]
    }
}

struct EventAreaGraphView: View {
    @StateObject private var viewModel = eventRevenueViewModel()

    var body: some View {
        VStack {
            Chart(viewModel.events) { event in
                AreaMark(
                    x: .value("Date", event.date),
                    y: .value("Revenue", event.ticketCount * event.ticketPrice)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.linearGradient(colors: [.librarianDashboardTabBar.opacity(0.8), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom))
            }
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 150) // Reduced height
            .padding(.horizontal) // Reduced padding
            .padding(.vertical, 10)
        }
    }
}

struct EventAreaGraphView_Previews: PreviewProvider {
    static var previews: some View {
        EventAreaGraphView()
    }
}



// MARK: Data and Graph for Line chart for no. of visitor in events
struct VisitorData: Identifiable {
    let id = UUID()
    let date: Date
    let visitors: Int
}

class EventVisitorViewData: ObservableObject {
    @Published var visitors: [VisitorData] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        visitors = [
            VisitorData(date: Date().addingTimeInterval(-6*24*60*60), visitors: 239),
            VisitorData(date: Date().addingTimeInterval(-5*24*60*60), visitors: 252),
            VisitorData(date: Date().addingTimeInterval(-4*24*60*60), visitors: 315),
            VisitorData(date: Date().addingTimeInterval(-3*24*60*60), visitors: 198),
            VisitorData(date: Date().addingTimeInterval(-2*24*60*60), visitors: 148),
            VisitorData(date: Date().addingTimeInterval(-1*24*60*60), visitors: 68),
            VisitorData(date: Date(), visitors: 183)
        ]
    }
}

struct VisitorLineChartView: View {
    let data: [VisitorData]

    var body: some View {
        Chart(data) { entry in
            LineMark(
                x: .value("Date", entry.date),
                y: .value("Visitors", entry.visitors)
            )
            .foregroundStyle(.brown)
            AreaMark(
                x: .value("Date", entry.date),
                y: .value("Visitors", entry.visitors)
            )
            .foregroundStyle(.linearGradient(colors: [.librarianDashboardTabBar.opacity(0.8), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom))
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.weekday())
            }
        }
        .chartYAxis {
            AxisMarks() { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .frame(height: 150) // Reduced height
        .padding(.horizontal) // Reduced padding
        .padding(.vertical, 10)
    }
}

struct LineChart: View {
    @ObservedObject var eventVisitorViewData = EventVisitorViewData()
    
    var body: some View {
        VStack {
            VisitorLineChartView(data: eventVisitorViewData.visitors)
                .padding(.horizontal) // Reduced padding
                .padding(.vertical, 10)

            Spacer()
        }
    }
}


#Preview("Line Chart"){
    LineChart()
}

//MARK: Data and Graph for Bar chart for no. of visitor in events

struct TicketData: Identifiable {
    let id = UUID()
    let day: String
    let ticketsSold: Int
    let ticketsAvailable: Int
}

class EventTicketSalesData: ObservableObject {
    @Published var tickets: [TicketData] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        tickets = [
            TicketData(day: "Mon", ticketsSold: 150, ticketsAvailable: 80),
            TicketData(day: "Tue", ticketsSold: 120, ticketsAvailable: 60),
            TicketData(day: "Wed", ticketsSold: 170, ticketsAvailable: 50),
            TicketData(day: "Thu", ticketsSold: 100, ticketsAvailable: 45),
            TicketData(day: "Fri", ticketsSold: 130, ticketsAvailable: 50),
            TicketData(day: "Sat", ticketsSold: 140, ticketsAvailable: 70),
            TicketData(day: "Sun", ticketsSold: 160, ticketsAvailable: 90)
        ]
    }
}

struct BarChartView: View {
    var data: [TicketData]
    let maxTickets = 200 // Assuming the max tickets for scaling

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(data) { entry in
                VStack {
                    HStack(alignment: .bottom, spacing: 4) {
                        // Ticket Sold
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.customButton)
                                .frame(width: 15, height: CGFloat(entry.ticketsSold) / CGFloat(maxTickets) * 100)
                        }
                        
                        // Ticket Available
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.librarianDashboardTabBar)
                                .frame(width: 15, height: CGFloat(entry.ticketsAvailable) / CGFloat(maxTickets) * 100)
                        }
                    }

                    Text(entry.day)
                        .font(.caption2)
                        
                }
            }
        }
        .padding()
    }
}

struct BarGraph: View {
    @StateObject private var viewModel = EventTicketSalesData()

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Circle()
                        .fill(Color.customButton)
                        .frame(width: 15, height: 15)
                    Text("200 Ticket Sold")
                        .font(.caption2)
                }
                
                HStack {
                    Circle()
                        .fill(Color.librarianDashboardTabBar)
                        .frame(width: 15, height: 15)
                    Text("330 Ticket Available")
                        .font(.caption2)
                }
            }
           
            BarChartView(data: viewModel.tickets)
            
            Spacer()
        }
        .padding()
    }
}


// Preview provider for the main view
#Preview("bar graph"){
    BarGraph()
}

#Preview{
    EventsDashboard()
}

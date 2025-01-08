<%@ page import="cowork.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !loggedInUser.getIs_admin()) {
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Statistiques d'utilisation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="container mt-4">
    <h1>Statistiques d'utilisation</h1>

    <!-- Filtres -->
    <div class="row mb-4">
        <div class="col-md-6">
            <form id="filterForm" class="row g-3">
                <div class="col-md-5">
                    <label for="startDate">Date début</label>
                    <input type="date" class="form-control" id="startDate" name="startDate" value="2021-01-01">
                </div>
                <div class="col-md-5">
                    <label for="endDate">Date fin</label>
                    <input type="date" class="form-control" id="endDate" name="endDate">
                </div>
                <div class="col-md-2">
                    <label>&nbsp;</label>
                    <button type="submit" class="btn btn-primary w-100">Filtrer</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Graphiques -->
    <div class="row">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Occupation par heure</h5>
                    <canvas id="hourlyChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Occupation par salle</h5>
                    <canvas id="roomChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Créneaux populaires -->
    <div class="row mt-4">
        <div class="col-md-12">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Créneaux les plus populaires</h5>
                    <div id="popularTimeSlots"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let hourlyChart, roomChart;

    function updateCharts(data) {
        let popularHtml = '';
        if (data.popularTimeSlots && data.popularTimeSlots.length > 0) {
            popularHtml = data.popularTimeSlots.map(slot => {
                console.log("Slot complet:", slot);
                return '<div class="alert alert-info">' +
                    '<strong>' + slot.startTime + ' - ' + slot.endTime + '</strong> : ' +
                    slot.count + ' réservation' + (slot.count > 1 ? 's' : '') +
                    '</div>';
            }).join('');

            console.log("HTML généré:", popularHtml);
        } else {
            popularHtml = '<div class="alert alert-info">Aucun créneau trouvé</div>';
        }

        const popularTimeSlotsElement = document.getElementById('popularTimeSlots');

        if (popularTimeSlotsElement) {
            popularTimeSlotsElement.innerHTML = popularHtml;
            console.log("HTML inséré dans le DOM:", popularTimeSlotsElement.innerHTML);
        } else {
            console.error("L'élément popularTimeSlots n'a pas été trouvé dans le DOM");
        }

        const hourlyData = {
            labels: data.occupationByHour.map(item => item.timeLabel),
            datasets: [{
                label: 'Nombre de réservations',
                data: data.occupationByHour.map(item => item.count),
                backgroundColor: 'rgba(54, 162, 235, 0.5)'
            }]
        };

        if (hourlyChart) {
            hourlyChart.destroy();
        }
        hourlyChart = new Chart(document.getElementById('hourlyChart'), {
            type: 'bar',
            data: hourlyData,
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        const roomData = {
            labels: data.occupationByRoom.map(item => item.room),
            datasets: [{
                label: 'Nombre de réservations',
                data: data.occupationByRoom.map(item => Number(item.count)),
                backgroundColor: 'rgba(255, 99, 132, 0.5)'
            }]
        };

        if (roomChart) {
            roomChart.destroy();
        }
        roomChart = new Chart(document.getElementById('roomChart'), {
            type: 'bar',
            data: roomData,
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    $('#filterForm').submit(function(e) {
        e.preventDefault();
        const startDate = $('#startDate').val();
        const endDate = $('#endDate').val();

        $.ajax({
            url: '/cowork/statistics',
            data: {
                startDate: startDate,
                endDate: endDate
            },
            success: function(data) {
                if (typeof data === 'string') {
                    data = JSON.parse(data);
                }
                updateCharts(data);
            },
            error: function(xhr, status, error) {
                console.error('Erreur:', error);
            }
        });
    });

    $(document).ready(function() {
        const today = new Date();
        const firstDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);

        $('#startDate').val(firstDayOfMonth.toISOString().split('T')[0]);
        $('#endDate').val(today.toISOString().split('T')[0]);

        $('#filterForm').submit();
    });
</script>
</body>
</html>
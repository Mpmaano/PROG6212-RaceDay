\# RaceDay API Endpoint Plan



| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |

|-------------|-------|-------------|---------------|--------------|-------------------|

| POST | /api/auth/register | Creates a new user account | None (public) | { email, password, firstName, lastName, role, phone } | 201 Created – user details |

| POST | /api/auth/login | Logs a user in and returns a token | None | { email, password } | 200 OK – token and user info |

| GET | /api/users/me | Gets the current logged-in user’s profile | Any logged-in user | None | 200 OK – profile |

| PUT | /api/users/me | Updates the current user’s profile | Any logged-in user | { firstName, lastName, phone } | 200 OK – updated profile |

| GET | /api/events | Lists all published events | None or Any | None | 200 OK – list of events |

| POST | /api/events | Creates a new event | Organiser | { title, description, eventDate, location, province } | 201 Created – new event |

| GET | /api/events/{id} | Gets one event and its categories | None or Any | None | 200 OK or 404 |

| PUT | /api/events/{id} | Updates an event | Organiser (must own it) | same fields as create | 200 OK |

| DELETE | /api/events/{id} | Deletes an event | Organiser (must own it) | None | 204 No Content |

| GET | /api/events/{eventId}/categories | Lists categories of an event | None or Any | None | 200 OK – categories |

| POST | /api/events/{eventId}/categories | Adds a category to an event | Organiser | { name, distanceKm, maxEntries, entryFee } | 201 Created |

| POST | /api/categories/{categoryId}/enrolments | Participant enrols in a category | Participant | { } | 201 Created or 409 Conflict |

| GET | /api/enrolments/my | Shows the participant’s own enrolments | Participant | None | 200 OK |

| GET | /api/events/{eventId}/enrolments | Organiser sees all people enrolled | Organiser | None | 200 OK |

| POST | /api/enrolments/{enrolmentId}/results | Organiser records a finish result | Organiser | { finishTime, position, chipTime } | 201 Created |

| GET | /api/results/my | Participant sees their own results | Participant | None | 200 OK |

